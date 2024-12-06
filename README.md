# Stadium_Reservation_System
The KIU Stadium Reservation System is a web-based application designed for managing stadium reservations at the university. The system allows students to reserve stadiums by specifying the desired time slots and ensures that all constraints are respected.

Features

Web Interface: User-friendly interface built using HTML and CSS.
Dynamic Backend: Python and Flask power the application, managing interactions between the frontend and the PostgreSQL database.
Database Integration: A robust database schema with enforced constraints to maintain data integrity.
Validation: Implements triggers and check constraints for automatic validation of reservation rules.
Diagrams:
ER Model: Visualizes the database structure.
Activity Diagram: Illustrates the application's workflow.
Technical Details

Backend
Language: Python
Framework: Flask
Main File: app.py (connects the frontend and database)

Frontend
Languages: HTML, CSS
Key File: index.html (reservation form interface)

Database
DBMS: PostgreSQL
Backup: Provided as stadiums_backup.sql
Schema: Includes Students, Stadiums, and Reservations tables with attributes like student_id, stadium_id, and reservation time details.
Diagrams
ER Model: Found in KIU_Stadiums_ER.html​
Activity Diagram: Found in activityDiagram_Kiu_stadiums.html​

# Usage

The KIU Stadium Reservation System is a web-based application that allows students to reserve university stadiums while adhering to predefined rules and constraints. To set up the system, first clone the repository and navigate to the project folder. Set up the PostgreSQL database by importing the provided schema from stadiums_backup.sql using the psql command, ensuring to replace the placeholder database credentials in app.py with your own. Next, create a virtual environment for the project and install the required dependencies listed in requirements.txt. Once the setup is complete, run the application by executing python app.py and access it through http://localhost:5000 in a web browser.

The system ensures that only students with valid KIU email addresses can make reservations. It enforces database rules such as restricting reservations to non-overlapping time slots, ensuring reservations are made within 48 hours of the current time, and preventing students from booking within 24 hours of their previous reservation. Additionally, students cannot reserve a stadium for more than 1.5 hours. The robust validation is implemented through database triggers and check constraints, maintaining the integrity of the reservation process.
