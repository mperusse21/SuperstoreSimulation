package database2project;

import java.util.Scanner;

public class AppUtilities {
    public static int setValidAction (Scanner reader, int max) {
        boolean isValid = false;
        int action = 0;
        while (!isValid){
            action = getValidInt(reader);
            if (action > 0 && action <= max){
                isValid = true;
            }
            else {
                System.out.println("Invalid input, must be between 1 and " + max);
            }
        }
        return action;
    }

    public static void handleReviewUpdate(Scanner reader, SuperStoreServices connection, int review_id){
        System.out.println("Choose an update option:");
        System.out.println("1. Update Score");
        System.out.println("2. Update Flag");
        System.out.println("3. Update Description");

        int choice = setValidAction(reader, 3);

        if (choice == 1){
            System.out.println("Enter the new score (from 1 to 5)");
            int score = reader.nextInt();
            connection.updateScore(review_id, score);
        }

        if (choice == 2){
            System.out.println("Enter the new flag value");
            int score = reader.nextInt();
            connection.updateFlag(review_id, score);
        }

        if (choice == 3){
            System.out.println("Enter the new description (or null)");
            // flush the scanner
            reader.nextLine();
            String description = reader.nextLine();
            if (description.equals("null")){
                description = null;
            }
            connection.updateDescription(review_id, description);
        }
    }

    /* prompts the user until they enter a valid int, prints a message if they enter a String or Double */
    public static int getValidInt (Scanner reader){
        boolean isValid = false;
        int validInt;

        while (!isValid){
            try {
                validInt = Integer.parseInt(reader.next());

                return validInt;
            }
            catch (IllegalArgumentException e){
                System.out.println("Invalid input, must enter an integer");
            }
        }
        // Will never be reached
        return -1;
    }
}
