import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import java.io.FileInputStream;
import java.io.FileNotFoundException;

/**
 * Created by Nils_Strelow on 21.05.2016.
 */
public class Main {


    public static void main(String[] args) {
        System.out.println("app is running!");

        FirebaseOptions options = null;
        try {
            options = new FirebaseOptions.Builder()
                    .setServiceAccount(new FileInputStream("dubwarsCredentials.json"))
                    .setDatabaseUrl("https://databaseName.firebaseio.com/")
                    .build();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        FirebaseApp.initializeApp(options);
    }
}
