package com.ionicframework.qarsan668811;

import android.os.Bundle;
import org.apache.cordova.*;
import java.util.*;
import com.firebase.client.*;

public class theBridge
{
    private static final boolean useFirebase = true;

    private static theBridge singleton = null;

    protected theBridge() {
        // Exists only to defeat instantiation.
        Firebase myFirebaseRef = new Firebase("https://brilliant-torch-1595.firebaseio.com/");
        myFirebaseRef.child("TEST").setValue("HI THERE");

        /* THIS IS HOW TO READ
        myFirebaseRef.child("message").addValueEventListener(new ValueEventListener() {
  @Override
  public void onDataChange(DataSnapshot snapshot) {
    System.out.println(snapshot.getValue());  //prints "Do you have data? You'll love Firebase."
  }
  @Override public void onCancelled(FirebaseError error) { }
});
         */
    }
    public static theBridge getInstance() {
        if(singleton == null) {
            singleton = new theBridge();
        }
        return singleton;
    }

    public void addArticle(String article, String articleTitle)
    {
        if (this.useFirebase)
        {

        }
    }

    public String getFullArticle(int id)
    {
        if (this.useFirebase)
        {

        }
        return "";
    }

    public ArrayList<storyClass> getArticleList()
    {
        if (this.useFirebase)
        {

        }
        return null;
    }
}