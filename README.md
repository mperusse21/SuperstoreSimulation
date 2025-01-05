# Fall2023Database2Project

Mitchell Perusse Student ID:2111028 and Mohammad Mahbub Rahman Student ID:2236383

GitLab Repository: https://gitlab.com/MohammadRahman/fall2023database2project.git

To setup the database:
	
 	1) Run remove.sql to remove existing data inside your Oracle database (example tables with the same name)

	2) Continue by running setup.sql to create all tables (including the audit table), types, and insert the relevant info.
	
	3) Run packages1.sql (made by Mohammad) to create all packages for the Stores, Addresses, Cities, Customers, Products tables.
	
	4) Run packages2.sql (made by Mitchell) to create all packages for the Orders, Reviews, Warehouses, and Inventory tables.
	
	5) Run triggers.sql to create all triggers for every table (made together).

	5) Once finished, move to java. In java, go to App.java which contains the user program and most of the code necessary for it to run.
	
	6) Compiling and then running the program will prompt the user to enter their username and password to login to the database. Once done they will have 
	access to all procedures/functions and will only be able with the database through the use of them.
	
Assumptions made: We made a few assumptions in the setup of our database, they are listed below:
				
	- That the order price doesn't depend on the date (even though in reality it probably would)
				
	- That all stores and warehouses are located in Canada
				
	- That one order id can represent multiple unique products (why we used a composite primary key for orders).
		
				
				
				
