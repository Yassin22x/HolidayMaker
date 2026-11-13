
using MySqlConnector;
using System.Globalization;

string password = Environment.GetEnvironmentVariable("MYSQL_PASSWORD") ?? "";
if (password == "")
{
    Console.WriteLine("MySQL-lösenord saknas.");
    return;
}

using var db = new MySqlConnection(
    $"Server=localhost;Port=3306;Database=holiday_maker;User ID=root;Password={password};");

try { db.Open(); }
catch (Exception ex) { Console.WriteLine("Anslutningsfel: " + ex.Message); return; }

int customerId = 0;

string Ask(string text)
{
    Console.Write(text);
    return Console.ReadLine()?.Trim() ?? "";
}

int Number(string text) =>
    int.TryParse(Ask(text), out int n) ? n : -1;

DateTime Date(string text) =>
    DateTime.TryParseExact(Ask(text + " (ÅÅÅÅ-MM-DD): "),
        "yyyy-MM-dd", CultureInfo.InvariantCulture,
        DateTimeStyles.None, out var d) ? d : DateTime.MinValue;

bool ValidDates(DateTime start, DateTime end) =>
    start.Year == 2026 && start.Month == 12 &&
    end.Year == 2026 && end.Month == 12 && end > start;

MySqlCommand Sql(string query, params object[] values)
{
    var cmd = new MySqlCommand(query, db);
    for (int i = 0; i < values.Length; i++)
        cmd.Parameters.AddWithValue("@p" + i, values[i]);
    return cmd;
}

void Show(string query, params object[] values)
{
    using var cmd = Sql(query, values);
    using var reader = cmd.ExecuteReader();
    bool found = false;

    while (reader.Read())
    {
        found = true;
        for (int i = 0; i < reader.FieldCount; i++)
            Console.Write(reader.GetName(i) + ": " + reader.GetValue(i) + "  ");
        Console.WriteLine();
    }

    if (!found) Console.WriteLine("Inga resultat.");
}

Console.WriteLine("Välkommen till Holiday Maker!");

while (true)
{
    Console.WriteLine("\n1. Visa/välj kund");
    Console.WriteLine("2. Registrera kund");
    Console.WriteLine("3. Sök lediga rum");
    Console.WriteLine("4. Boka rum");
    Console.WriteLine("5. Visa kundens bokningar");
    Console.WriteLine("6. Ändra antal gäster");
    Console.WriteLine("7. Avboka");
    Console.WriteLine("0. Avsluta");
    Console.WriteLine("Vald kund: " + (customerId == 0 ? "Ingen" : customerId));

    string choice = Ask("Välj: ");
    if (choice == "0") break;

    try
    {
        if (choice == "1")
        {
            Show("SELECT customer_id, name FROM CUSTOMER");
            int id = Number("Ange kund-ID: ");

            using var cmd = Sql(
                "SELECT COUNT(*) FROM CUSTOMER WHERE customer_id=@p0", id);

            if (Convert.ToInt32(cmd.ExecuteScalar()) == 1)
            {
                customerId = id;
                Console.WriteLine("Kund vald!");
            }
            else Console.WriteLine("Kunden finns inte.");
        }
        else if (choice == "2")
        {
            string name = Ask("Namn: ");
            string email = Ask("E-post: ");
            string phone = Ask("Telefon: ");

            if (name == "" || email == "" || phone == "")
            {
                Console.WriteLine("Alla fält måste fyllas i.");
                continue;
            }

            using var cmd = Sql(
                "INSERT INTO CUSTOMER(name,email,phone) VALUES(@p0,@p1,@p2)",
                name, email, phone);

            cmd.ExecuteNonQuery();
            customerId = (int)cmd.LastInsertedId;
            Console.WriteLine("Kund registrerad! ID: " + customerId);
        }
        else if (choice == "3")
        {
            string city = Ask("Stad: ");
            DateTime start = Date("Incheckning");
            DateTime end = Date("Utcheckning");
            int guests = Number("Antal gäster: ");

            if (!ValidDates(start, end) || guests < 1 || city == "")
            {
                Console.WriteLine("Ogiltiga datum, stad eller antal gäster.");
                continue;
            }

            bool pool = Ask("Krävs pool? (j/n): ").ToLower() == "j";
            bool restaurant = Ask("Krävs restaurang? (j/n): ").ToLower() == "j";
            int beach = Number("Max avstånd till strand (0 = inget krav): ");
            int center = Number("Max avstånd till centrum (0 = inget krav): ");
            string sort = Ask("Sortera 1 = pris, 2 = betyg: ");

            string order = sort == "2" ? "A.rating DESC" : "R.price_per_night ASC";

            Show($@"SELECT R.room_id, A.name AS hotell, A.city AS stad,
                    R.room_number AS rum, R.capacity AS platser,
                    R.price_per_night AS pris, A.rating AS betyg
                    FROM ROOM R JOIN ACCOMMODATION A
                    ON R.accommodation_id=A.accommodation_id
                    WHERE A.city=@p0 AND R.capacity>=@p1
                    AND (@p2=0 OR A.has_pool=1)
                    AND (@p3=0 OR A.has_restaurant=1)
                    AND (@p4<=0 OR A.distance_beach<=@p4)
                    AND (@p5<=0 OR A.distance_center<=@p5)
                    AND NOT EXISTS(
                        SELECT 1 FROM BOOKING B WHERE B.room_id=R.room_id
                        AND B.check_in<@p6 AND B.check_out>@p7)
                    ORDER BY {order}",
                city, guests, pool ? 1 : 0, restaurant ? 1 : 0,
                beach, center, end, start);
        }
        else if (choice == "4")
        {
            if (customerId == 0)
            {
                Console.WriteLine("Välj kund först.");
                continue;
            }

            int room = Number("Rum-ID: ");
            DateTime start = Date("Incheckning");
            DateTime end = Date("Utcheckning");
            int guests = Number("Antal gäster: ");

            if (!ValidDates(start, end) || guests < 1)
            {
                Console.WriteLine("Ogiltiga datum eller antal gäster.");
                continue;
            }

            using var transaction = db.BeginTransaction();

            try
            {
                int capacity;
                decimal price;

                using (var cmd = Sql(
                    "SELECT capacity,price_per_night FROM ROOM WHERE room_id=@p0 FOR UPDATE",
                    room))
                {
                    cmd.Transaction = transaction;

                    using var reader = cmd.ExecuteReader();

                    if (!reader.Read())
                    {
                        Console.WriteLine("Rummet finns inte.");
                        transaction.Rollback();
                        continue;
                    }

                    capacity = reader.GetInt32(0);
                    price = reader.GetDecimal(1);
                }

                using var check = Sql(
                    @"SELECT COUNT(*) FROM BOOKING
                      WHERE room_id=@p0 AND check_in<@p1 AND check_out>@p2",
                    room, end, start);

                check.Transaction = transaction;
                int occupied = Convert.ToInt32(check.ExecuteScalar());

                if (guests > capacity || occupied > 0)
                {
                    Console.WriteLine("Rummet är upptaget eller för litet.");
                    transaction.Rollback();
                    continue;
                }

                using var booking = Sql(
                    @"INSERT INTO BOOKING
                      (customer_id,room_id,check_in,check_out,number_of_guests)
                      VALUES(@p0,@p1,@p2,@p3,@p4)",
                    customerId, room, start, end, guests);

                booking.Transaction = transaction;
                booking.ExecuteNonQuery();

                long bookingId = booking.LastInsertedId;
                transaction.Commit();

                decimal total = (end - start).Days * price;
                Console.WriteLine($"Bokning {bookingId} klar! Totalt: {total} kr");
            }
            catch
            {
                transaction.Rollback();
                throw;
            }
        }
        else if (choice == "5")
        {
            if (customerId == 0)
            {
                Console.WriteLine("Välj kund först.");
                continue;
            }

            Show(@"SELECT B.booking_id AS bokning, A.name AS hotell,
                   R.room_number AS rum, B.check_in, B.check_out,
                   B.number_of_guests AS gäster,
                   DATEDIFF(B.check_out,B.check_in)*R.price_per_night AS totalpris
                   FROM BOOKING B JOIN ROOM R ON B.room_id=R.room_id
                   JOIN ACCOMMODATION A ON R.accommodation_id=A.accommodation_id
                   WHERE B.customer_id=@p0 ORDER BY B.check_in", customerId);
        }
        else if (choice == "6")
        {
            if (customerId == 0)
            {
                Console.WriteLine("Välj kund först.");
                continue;
            }

            int booking = Number("Boknings-ID: ");
            int guests = Number("Nytt antal gäster: ");

            using var cmd = Sql(
                @"UPDATE BOOKING B JOIN ROOM R ON B.room_id=R.room_id
                  SET B.number_of_guests=@p0
                  WHERE B.booking_id=@p1 AND B.customer_id=@p2
                  AND @p0>=1 AND @p0<=R.capacity",
                guests, booking, customerId);

            Console.WriteLine(cmd.ExecuteNonQuery() > 0
                ? "Antal gäster uppdaterat!"
                : "Ingen ändring gjord.");
        }
        else if (choice == "7")
        {
            if (customerId == 0)
            {
                Console.WriteLine("Välj kund först.");
                continue;
            }

            int booking = Number("Boknings-ID: ");

            if (Ask("Bekräfta avbokning (ja/nej): ").ToLower() != "ja")
                continue;

            using var cmd = Sql(
                "DELETE FROM BOOKING WHERE booking_id=@p0 AND customer_id=@p1",
                booking, customerId);

            Console.WriteLine(cmd.ExecuteNonQuery() > 0
                ? "Bokningen avbokad!"
                : "Bokningen hittades inte.");
        }
        else Console.WriteLine("Ogiltigt val.");
    }
    catch (Exception ex)
    {
        Console.WriteLine("Fel: " + ex.Message);
    }
}
