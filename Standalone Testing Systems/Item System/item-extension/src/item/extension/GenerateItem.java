package item.extension;

import java.sql.SQLException;

import com.smartfoxserver.v2.db.IDBManager;
import com.smartfoxserver.v2.entities.User;
import com.smartfoxserver.v2.entities.data.ISFSArray;
import com.smartfoxserver.v2.entities.data.ISFSObject;
import com.smartfoxserver.v2.entities.data.SFSArray;
import com.smartfoxserver.v2.entities.data.SFSObject;
import com.smartfoxserver.v2.extensions.BaseClientRequestHandler;
import com.smartfoxserver.v2.extensions.ExtensionLogLevel;
import java.util.ArrayList;

import java.util.Random;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class GenerateItem extends BaseClientRequestHandler {

    @Override
    public void handleClientRequest(User sender, ISFSObject params) {
        IDBManager dbManager = getParentExtension().getParentZone().getDBManager();
        trace(">>>>>>>>>>>>>>>>>>>> RUNNINNG >>>>>>>>>>>>>>>>>>>>>");        
        
        Random randomGenerator = new Random();
        int prefixRandomizer, baseRandomizer, suffixRandomizer=0;
        int rarityDecider=0;
        String sql="";
        
        ISFSObject selectedPrefix, selectedBase, selectedSuffix;
        ISFSArray prefixArray;
        ISFSArray baseArray;
        ISFSArray suffixArray;
        
        
    
            
        rarityDecider = randomGenerator.nextInt (100);//randomly picks a num between 1 and 100
        try {
            //<editor-fold defaultstate="collapsed" desc="Executing query on server and retrieving only necessary bits">
            if (rarityDecider <= 60)//common item = 65% chance of getting
            {
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='prefix'";
                prefixArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='base'";
                baseArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='suffix'";
                suffixArray = dbManager.executeQuery (sql);
            }
            else if (rarityDecider > 60 && rarityDecider < 85)
            {
                sql="SELECT * FROM modifiers WHERE rarity = 2 AND type='prefix'";
                prefixArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 2 AND type='base'";
                baseArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 2 AND type='suffix'";
                suffixArray = dbManager.executeQuery (sql);
            }
            else if (rarityDecider > 85 && rarityDecider < 95)
            {
                sql="SELECT * FROM modifiers WHERE rarity = 3 AND type='prefix'";
                prefixArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 3 AND type='base'";
                baseArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 3 AND type='suffix'";
                suffixArray = dbManager.executeQuery (sql);
            }
            else if (rarityDecider >95 && rarityDecider <101)
            {
                sql="SELECT * FROM modifiers WHERE rarity = 4 AND type='prefix'";
                prefixArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 4 AND type='base'";
                baseArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 4 AND type='suffix'";
                suffixArray = dbManager.executeQuery (sql);
            }    
            else 
            {
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='prefix'";
                prefixArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='base'";
                baseArray = dbManager.executeQuery (sql);
                sql="SELECT * FROM modifiers WHERE rarity = 1 AND type='suffix'";
                suffixArray = dbManager.executeQuery (sql);
            }
            //</editor-fold>
                        
            //<editor-fold defaultstate="collapsed" desc="randomly picking a prefix/suffix/base">
            prefixRandomizer = randomGenerator.nextInt(prefixArray.size());
            baseRandomizer= randomGenerator.nextInt (baseArray.size());
            suffixRandomizer = randomGenerator.nextInt (suffixArray.size());
            
            selectedPrefix = prefixArray.getSFSObject(prefixRandomizer);
            selectedBase = baseArray.getSFSObject(baseRandomizer);
            selectedSuffix = suffixArray.getSFSObject(suffixRandomizer);
            //</editor-fold>
            Set<String> keys = selectedPrefix.getKeys();
            
               // var keys:Array = sfsObj.getKeys(); 
       //  var obj:Object = new Object(); 
       //  for(var i:int = 0; i<keys.length; i++){ 
       //     obj[keys[i]] = SFSDataWrapper(sfsObj.getData(keys[i])).data; 
            

        } catch (SQLException e) {
            trace(ExtensionLogLevel.WARN, "SQL Failed: " + e.toString());
        }
    }
}
