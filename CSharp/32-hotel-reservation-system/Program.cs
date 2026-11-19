
using System;
using System.Collections.Generic;

class Room
{
    public int RoomNumber;
    public string RoomType;
    public decimal PricePerNight;
    public bool IsAvailable;

    public Room(int number, string type, decimal price)
    {
        RoomNumber = number;
        RoomType = type;
        PricePerNight = price;
        IsAvailable = true;
    }
}

class Reservation
{
    public int ReservationId;
    public string CustomerName;
    public Room ReservedRoom;
    public DateTime CheckIn;
    public DateTime CheckOut;
    public decimal TotalCost;

    public Reservation(int id, string name, Room room,
        DateTime checkIn, DateTime checkOut)
    {
        ReservationId = id;
        CustomerName = name;
        ReservedRoom = room;
        CheckIn = checkIn;
        CheckOut = checkOut;

        int nights = (checkOut - checkIn).Days;
        TotalCost = nights * room.PricePerNight;
    }
}

class Program
{
    static List<Room> rooms = new List<Room>();
    static List<Reservation> reservations = new List<Reservation>();
    static int nextReservationId = 1;

    static void Main()
    {
        addRooms();

        bool running = true;

        while (running)
        {
            Console.WriteLine("\n===== HOTEL RESERVATION SYSTEM =====");
            Console.WriteLine("1. View available rooms");
            Console.WriteLine("2. Make a reservation");
            Console.WriteLine("3. View all reservations");
            Console.WriteLine("4. Search reservation");
            Console.WriteLine("5. Cancel reservation");
            Console.WriteLine("6. Exit");
            Console.Write("Choose an option: ");

            string choice = Console.ReadLine() ?? "";

            switch (choice)
            {
                case "1":
                    showAvailableRooms();
                    break;

                case "2":
                    makeReservation();
                    break;

                case "3":
                    showReservations();
                    break;

                case "4":
                    searchReservation();
                    break;

                case "5":
                    cancelReservation();
                    break;

                case "6":
                    running = false;
                    Console.WriteLine("Thank you for using our hotel system!");
                    break;

                default:
                    Console.WriteLine("Invalid choice. Please try again.");
                    break;
            }
        }
    }

    static void addRooms()
    {
        rooms.Add(new Room(101, "Single", 3000));
        rooms.Add(new Room(102, "Single", 3000));
        rooms.Add(new Room(201, "Double", 5000));
        rooms.Add(new Room(202, "Double", 5000));
        rooms.Add(new Room(301, "Suite", 9000));
    }

    static void showAvailableRooms()
    {
        Console.WriteLine("\n--- Available Rooms ---");

        bool found = false;

        foreach (Room room in rooms)
        {
            if (room.IsAvailable)
            {
                Console.WriteLine("Room: " + room.RoomNumber);
                Console.WriteLine("Type: " + room.RoomType);
                Console.WriteLine("Price per night: " +
                    room.PricePerNight.ToString("F2"));
                Console.WriteLine("------------------------");

                found = true;
            }
        }

        if (!found)
        {
            Console.WriteLine("No rooms are currently available.");
        }
    }

    static void makeReservation()
    {
        showAvailableRooms();

        Console.Write("\nEnter room number: ");
        string roomInput = Console.ReadLine() ?? "";

        if (!int.TryParse(roomInput, out int roomNumber))
        {
            Console.WriteLine("Invalid room number.");
            return;
        }

        Room? selectedRoom = null;

        foreach (Room room in rooms)
        {
            if (room.RoomNumber == roomNumber && room.IsAvailable)
            {
                selectedRoom = room;
                break;
            }
        }

        if (selectedRoom == null)
        {
            Console.WriteLine("Room not found or already reserved.");
            return;
        }

        Console.Write("Enter customer name: ");
        string name = (Console.ReadLine() ?? "").Trim();

        if (string.IsNullOrWhiteSpace(name))
        {
            Console.WriteLine("Customer name cannot be empty.");
            return;
        }

        Console.Write("Enter check-in date (yyyy-MM-dd): ");
        if (!DateTime.TryParse(Console.ReadLine(), out DateTime checkIn))
        {
            Console.WriteLine("Invalid check-in date.");
            return;
        }

        Console.Write("Enter check-out date (yyyy-MM-dd): ");
        if (!DateTime.TryParse(Console.ReadLine(), out DateTime checkOut))
        {
            Console.WriteLine("Invalid check-out date.");
            return;
        }

        if (checkIn.Date < DateTime.Today)
        {
            Console.WriteLine("Check-in date cannot be in the past.");
            return;
        }

        if (checkOut.Date <= checkIn.Date)
        {
            Console.WriteLine("Check-out must be after check-in.");
            return;
        }

        Reservation reservation = new Reservation(
            nextReservationId,
            name,
            selectedRoom,
            checkIn,
            checkOut
        );

        reservations.Add(reservation);
        selectedRoom.IsAvailable = false;
        nextReservationId++;

        Console.WriteLine("\nReservation created successfully!");
        Console.WriteLine("Reservation ID: " + reservation.ReservationId);
        Console.WriteLine("Total cost: " + reservation.TotalCost.ToString("F2"));
    }

    static void showReservations()
    {
        if (reservations.Count == 0)
        {
            Console.WriteLine("No reservations found.");
            return;
        }

        Console.WriteLine("\n--- All Reservations ---");

        foreach (Reservation reservation in reservations)
        {
            displayReservation(reservation);
        }
    }

    static void searchReservation()
    {
        Console.Write("Enter customer name: ");
        string name = (Console.ReadLine() ?? "").Trim();

        bool found = false;

        foreach (Reservation reservation in reservations)
        {
            if (reservation.CustomerName.Contains(
                name, StringComparison.OrdinalIgnoreCase))
            {
                displayReservation(reservation);
                found = true;
            }
        }

        if (!found)
        {
            Console.WriteLine("No reservation found for this customer.");
        }
    }

    static void cancelReservation()
    {
        Console.Write("Enter reservation ID: ");
        string input = Console.ReadLine() ?? "";

        if (!int.TryParse(input, out int id))
        {
            Console.WriteLine("Invalid reservation ID.");
            return;
        }

        Reservation? selectedReservation = null;

        foreach (Reservation reservation in reservations)
        {
            if (reservation.ReservationId == id)
            {
                selectedReservation = reservation;
                break;
            }
        }

        if (selectedReservation == null)
        {
            Console.WriteLine("Reservation not found.");
            return;
        }

        selectedReservation.ReservedRoom.IsAvailable = true;
        reservations.Remove(selectedReservation);

        Console.WriteLine("Reservation cancelled successfully.");
    }

    static void displayReservation(Reservation reservation)
    {
        Console.WriteLine("\nReservation ID: " + reservation.ReservationId);
        Console.WriteLine("Customer: " + reservation.CustomerName);
        Console.WriteLine("Room: " + reservation.ReservedRoom.RoomNumber);
        Console.WriteLine("Room type: " + reservation.ReservedRoom.RoomType);
        Console.WriteLine("Check-in: " + reservation.CheckIn.ToString("yyyy-MM-dd"));
        Console.WriteLine("Check-out: " + reservation.CheckOut.ToString("yyyy-MM-dd"));
        Console.WriteLine("Total cost: " + reservation.TotalCost.ToString("F2"));
        Console.WriteLine("------------------------");
    }
}
