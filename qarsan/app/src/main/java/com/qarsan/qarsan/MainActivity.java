package com.qarsan.qarsan;

import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.util.Log;
import android.view.MenuItem;

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
import java.util.*;
import java.io.*;

public class MainActivity extends ActionBarActivity {
    final private static Random rnd = new Random(42L);

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        System.setProperty("java.net.preferIPv6Addresses", "false");
        Peer master = null;
        try
        {
            master = new Peer(new Number160(rnd));
            Bindings bindings=new Bindings();
            bindings.addProtocol(Bindings.Protocol.IPv4);
            master.listen(4001, 4001, bindings);
            Peer[] nodes = createAndAttachNodes(master, 10);
            bootstrap(master, nodes);
            examplePutGet(nodes);
            exampleAddGet(nodes);
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

    private static Peer[] createAndAttachNodes(Peer master, int nr) throws Exception
    {
        Peer[] nodes = new Peer[nr];
        nodes[0] = master;
        for (int i = 1; i < nr; i++)
        {
            nodes[i] = new Peer(new Number160(rnd));
            nodes[i].listen(master);
        }
        return nodes;
    }

    private static void bootstrap(Peer master, Peer[] nodes)
    {
        List<FutureBootstrap> futures = new ArrayList<FutureBootstrap>();
        for (int i = 1; i < nodes.length; i++)
        {
            FutureBootstrap tmp = nodes[i].bootstrap(master.getPeerAddress());
            futures.add(tmp);
        }
        for (FutureBootstrap future : futures)
            future.awaitUninterruptibly();
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
