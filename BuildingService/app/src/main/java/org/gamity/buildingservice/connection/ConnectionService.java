package org.gamity.buildingservice.connection;

import android.text.Editable;

import java.sql.Connection;

public class ConnectionService {
    private String user;
    private String password;

    public ConnectionService (String user, String password) {
        this.user = user;
        this.password = password;
    }

    public void connect () {

    }

    public void stop () {

    }
}
