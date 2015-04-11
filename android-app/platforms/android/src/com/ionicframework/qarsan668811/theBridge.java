package com.ionicframework.qarsan668811;

import android.os.Bundle;
import org.apache.cordova.*;
import java.util.*;

public class theBridge
{
    private static final boolean useFirebase = true;

    private static theBridge singleton = null;

    protected theBridge() {
        // Exists only to defeat instantiation.
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