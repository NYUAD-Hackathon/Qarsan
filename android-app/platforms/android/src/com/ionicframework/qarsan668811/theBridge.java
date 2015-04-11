package com.ionicframework.qarsan668811;

import android.os.Bundle;
import org.apache.cordova.*;

public class theBridge
{
    private static final int useFirebase = 1;

    private static theBridge singleton = null;

    protected theBridge() {
        // Exists only to defeat instantiation.
    }
    public static theBridge getInstance() {
        if(singleton == null) {
            singleton = new Singleton();
        }
        return singleton;
    }

    public void addArticle(String article, String articleTitle)
    {
        if (useFirebase)
        {

        }
    }

    public String getFullArticle(int id)
    {
        if (useFirebase)
        {

        }
    }

    public Array<storyClass> getArticleList()
    {
        if (useFirebase)
        {

        }
    }
}