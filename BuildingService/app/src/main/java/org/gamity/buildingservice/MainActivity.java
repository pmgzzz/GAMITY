package org.gamity.buildingservice;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import org.gamity.buildingservice.connection.ConnectionService;
import org.gamity.buildingservice.sessions.BuildingSession;
import org.gamity.buildingservice.sessions.SOS;

import java.time.LocalDateTime;
import java.util.Calendar;
import java.util.Date;

public class MainActivity extends AppCompatActivity {

    public static ConnectionService connectionService;
    public static BuildingSession buildingSession;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final String[] phoneArr = { "+7 (977) 701-02-03" };
        Button btnLogin = (Button)findViewById(R.id.btnLogin);

        //final EditText editTextPhone = (EditText)findViewById(R.id.editTextPhone);
        final EditText editTextNumberPassword = (EditText)findViewById(R.id.editTextNumberPassword);
        final TextView textViewLogo = (TextView)findViewById(R.id.textViewLogo);
        final AutoCompleteTextView autoCompleteTextViewPhone = findViewById(R.id.autoCompleteTextViewPhone);
        autoCompleteTextViewPhone.setAdapter(new ArrayAdapter<>(this,
                android.R.layout.simple_dropdown_item_1line, phoneArr));

        btnLogin.setOnClickListener(new View.OnClickListener(){
            public void onClick(View arg0) {
                connectionService = new ConnectionService( autoCompleteTextViewPhone.getText().toString(), editTextNumberPassword.getText().toString() );
                openNewSession();
            }
        });
    }

    public static BuildingSession getBuildingSession () {
        return buildingSession;
    }

    private void openMainActivity () {
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, MainActivity.class);
        startActivity(intent);
    }

    private void openNewSession () {
        Intent intent = new Intent();
        intent.setClass(MainActivity.this, NewSessionActivity.class);
        startActivity(intent);
    }

    @SuppressLint("NewApi")
    private void newBuildingSession () {
        buildingSession = new BuildingSession(Calendar.getInstance().getTime());
    }

    private void closeCurrentBuildingSession () {
        if (buildingSession != null) { buildingSession.close(); }
    }

    private void stopConnectionService () {
        if (connectionService != null) { connectionService.stop(); }
    }
}