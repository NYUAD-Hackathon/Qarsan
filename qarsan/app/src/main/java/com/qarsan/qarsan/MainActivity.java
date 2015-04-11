package com.qarsan.qarsan;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;

import net.tomp2p.p2p.*;
import net.tomp2p.p2p.config.*;
import net.tomp2p.connection.*;
import net.tomp2p.connection.Bindings.Protocol;
import net.tomp2p.futures.*;
import net.tomp2p.log.*;
import net.tomp2p.mapreduce.*;
import net.tomp2p.message.*;
import net.tomp2p.natpmp.*;
import net.tomp2p.peers.*;
import net.tomp2p.replication.*;
import net.tomp2p.rpc.*;
import net.tomp2p.storage.*;
import net.tomp2p.upnp.*;
import net.tomp2p.utils.*;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.util.*;
import java.io.*;

public class MainActivity extends ActionBarActivity {
    final private static Random rnd = new Random(42L);
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        System.setProperty("java.net.preferIPv6Addresses", "false");


    }


    public void onClickButton(View view){
        EditText ipaddress = (EditText)findViewById(R.id.editText);
        String ip = ipaddress.getText().toString();
        Peer master = null;
        InetSocketAddress bootstrapIP = null;
        try
        {
            master = new Peer(new Number160(rnd));
            Bindings bindings=new Bindings(Bindings.Protocol.IPv4);
            master.listen(4001, 4001, bindings);

            //If 0.0.0.0 then we want to set up a default instance
            if(ip.equals("0.0.0.0")) {
            } else {
                //We were actually passed in an IP to connect to
                InetAddress ipaddr= InetAddress.getByName(ip);
                bootstrapIP = new InetSocketAddress(ipaddr,4001);
                master.bootstrap(bootstrapIP);
            }
        }
        catch (Throwable e)
        {
            Log.wtf("tomp2p", e);
            e.printStackTrace();
        }
        finally
        {
            if (master != null) {
                master.shutdown();
            }
        }
    }

    public static void examplePutGet(Peer[] nodes) throws IOException
    {
        Number160 nr = new Number160(rnd);
        String toStore = "hallo";
        Data data = new Data(toStore.getBytes());
        FutureDHT futureDHT = nodes[3].put(nr, data);
        futureDHT.awaitUninterruptibly();
        System.out.println("stored: " + toStore + " (" + futureDHT.isSuccess() + ")");
        futureDHT = nodes[7].get(nr);
        futureDHT.awaitUninterruptibly();
        //there are easier ways to get it, but this is for demonstration
        Data d1=futureDHT.getRawData().values().iterator().next().values().iterator().next();
        System.out.println("got: "
                + new String(d1.getData(),d1.getOffset(),d1.getLength()) + " (" + futureDHT.isSuccess() + ")");
    }

    private static void exampleAddGet(Peer[] nodes) throws IOException
    {
        Number160 nr = new Number160(rnd);
        String toStore1 = "hallo1";
        String toStore2 = "hallo2";
        Data data1 = new Data(toStore1.getBytes());
        Data data2 = new Data(toStore2.getBytes());
        FutureDHT futureDHT = nodes[3].add(nr, data1);
        futureDHT.awaitUninterruptibly();
        System.out.println("added: " + toStore1 + " (" + futureDHT.isSuccess() + ")");
        futureDHT = nodes[5].add(nr, data2);
        futureDHT.awaitUninterruptibly();
        System.out.println("added: " + toStore2 + " (" + futureDHT.isSuccess() + ")");
        futureDHT = nodes[7].getAll(nr);
        futureDHT.awaitUninterruptibly();
        System.out.println("size " + futureDHT.getData().size());
        Iterator<Data> iterator = futureDHT.getData().values().iterator();
        Data d1=iterator.next();
        Data d2=iterator.next();
        System.out.println("got: " + new String(d1.getData(),d1.getOffset(),d1.getLength()) + " ("
                + futureDHT.isSuccess() + ")");
        System.out.println("got: " + new String(d2.getData(),d2.getOffset(),d2.getLength()) + " ("
                + futureDHT.isSuccess() + ")");
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }
}
