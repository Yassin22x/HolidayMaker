# Holiday Maker

## Om projektet

Holiday Maker är ett bokningssystem som jag har utvecklat i C# med en MySQL-databas.

Syftet med projektet är att skapa ett enkelt system för en resebyrå där användaren kan hantera kunder, söka efter lediga hotellrum och administrera bokningar.

Programmet körs i terminalen och har en meny med olika funktioner.

## Tekniker

- C# och .NET
- MySQL
- MySqlConnector
- Visual Studio Code
- DataGrip

## Programmets funktioner

Programmet innehåller följande menyalternativ:

1. Visa och välja kund
2. Registrera ny kund
3. Söka efter lediga rum
4. Boka rum
5. Visa kundens bokningar
6. Ändra antal gäster
7. Avboka bokning
0. Avsluta programmet

Vid rumsökning kan användaren ange datum, antal gäster och olika önskemål för boendet.

Programmet kontrollerar att rummet är ledigt under den valda perioden och att antalet gäster inte överstiger rummets kapacitet.

## Databasstruktur

Databasen heter `holiday_maker` och består av fyra tabeller:

- **CUSTOMER** – lagrar kunduppgifter
- **ACCOMMODATION** – innehåller information om hotell och boenden
- **ROOM** – innehåller rum, priser och kapacitet
- **BOOKING** – lagrar bokningar och kopplar kunder till rum

Tabellerna är kopplade till varandra genom primärnycklar och främmande nycklar.

Databasens struktur och relationer visas i det bifogade ER-diagrammet.

## Starta programmet

Projektet kräver .NET SDK och MySQL Server.

Databasen `holiday_maker` kan återskapas genom den bifogade SQL-dumpfilen.

Programmet ansluter till en lokal MySQL-server via `localhost`, port `3306`, med användaren `root`.

Databaslösenordet hämtas från miljövariabeln `MYSQL_PASSWORD`, som behöver innehålla lösenordet för den lokala MySQL-användaren.

Programmet startas från projektmappen med:

```bash
dotnet restore
dotnet run
```

## Testning

Jag har testat programmets funktioner manuellt genom konsolmenyn.

Testningen omfattar:

- Visa befintliga kunder och registrera nya
- Söka efter lediga hotellrum
- Skapa och visa bokningar
- Ändra antal gäster i en bokning
- Avboka bokningar
- Kontrollera att rum inte dubbelbokas under samma period

Jag har även kontrollerat att informationen lagras i MySQL och kan hämtas igen.

## Projektfiler

- `Program.cs` – programmets kod och meny
- `HolidayMaker.csproj` – projektinställningar och beroenden
- SQL-dumpfil – databasstruktur och testdata
- ER-diagram – databasens struktur och relationer
- `README.md` – information om projektet och hur det startas

## Sammanfattning

I projektet har jag arbetat med att koppla samman ett C#-program med en relationsdatabas i MySQL.

Jag har skapat en databas med tabeller och relationer samt ett konsolprogram som använder databasen för att hantera kunder, hotellrum och bokningar.

Projektet har gett mig praktisk erfarenhet av SQL, relationsdatabaser och databasanslutning i C#.

OBS- Skulle det på något konstigt sätt inte tillåta ett annat lösen, så är det chcLxa4E
