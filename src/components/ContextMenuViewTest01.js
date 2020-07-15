import React from 'react';
import { StyleSheet, View, Text, Image } from 'react-native';
import Proptypes from 'prop-types';

import { ContextMenuView, MenuItemKeys, ImageTypes, MenuElementState, MenuElementAtrributes, MenuOptions } from 'app/src/components_native/ContextMenuView';



const menuItemsDummy1 = [{
    [MenuItemKeys.key           ]: 'key-01',
    [MenuItemKeys.title         ]: 'Disabled Action #1',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'folder.fill',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [MenuElementAtrributes.disabled],
  },{
    [MenuItemKeys.key           ]: 'key-02',
    [MenuItemKeys.title         ]: 'Normal Action #2',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'archivebox.fill',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [],
  },{
    [MenuItemKeys.key           ]: 'key-03',
    [MenuItemKeys.title         ]: 'MenuState: On',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'folder.fill',
    [MenuItemKeys.menuState     ]: MenuElementState.on,
    [MenuItemKeys.menuAttributes]: [],
  },{
    [MenuItemKeys.key           ]: 'key-04',
    [MenuItemKeys.title         ]: 'Normal Action #4',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'dial',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [],
  },{
    [MenuItemKeys.key           ]: 'key-05',
    [MenuItemKeys.title         ]: 'Destructive Action',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'trash.fill',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [MenuElementAtrributes.destructive],
  }
];

const menuItemsDummy2 = [{
    [MenuItemKeys.key           ]: 'ActionEdit',
    [MenuItemKeys.title         ]: 'Edit...',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'pencil',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [],
  },{
    [MenuItemKeys.key           ]: 'ActionDelete',
    [MenuItemKeys.title         ]: 'Delete',
    [MenuItemKeys.imageType     ]: ImageTypes.SYSTEM,
    [MenuItemKeys.imageValue    ]: 'trash.fill',
    [MenuItemKeys.menuState     ]: MenuElementState.off,
    [MenuItemKeys.menuAttributes]: [MenuElementAtrributes.destructive],
  }
];

export class ContextMenuViewTest01 extends React.PureComponent {
  render(){
    return(
      <View style={styles.rootContainer}>
        <ContextMenuView 
          style={styles.contextMenuView}
          menuItems={menuItemsDummy1}
          menuTitle={'Menu Test - displayInline'}
          menuOptions={[MenuOptions.displayInline]}
        >
          <Text style={styles.text}>
            {'React Native View'}
          </Text>
        </ContextMenuView>
        <ContextMenuView 
          style={styles.contextMenuView}
          menuItems={menuItemsDummy2}
          menuTitle={'Hello World'}
        >
          <Text style={styles.text}>
            {'Hello World'}
          </Text>
          <Text style={styles.text}>
            {'Hello World'}
          </Text>
          <Text style={styles.text}>
            {'Hello World'}
          </Text>
        </ContextMenuView>
        <ContextMenuView 
          style={styles.contextMenuViewImage}
          menuItems={menuItemsDummy2}
          menuTitle={'Image Preview'}
        >
          <Image
            style={styles.image}
            resizeMode={'cover'}
            source={require('app/assets/images/macos11_wallpaper.jpg')}
          />
        </ContextMenuView>
      </View>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  contextMenuView: {
    paddingHorizontal: 20,
    paddingVertical: 10,
    borderRadius: 10,
    backgroundColor: 'grey',
    margin: 15,
  },
  contextMenuViewImage: {
    margin: 15,
  },
  image: {
    width: 200,
    height: 100,
    borderRadius: 10,
  },
  text: {
    fontSize: 24,
    fontWeight: 'bold',
  },
});