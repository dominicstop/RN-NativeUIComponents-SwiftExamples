import React from 'react';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, ScrollView } from 'react-native';
import Proptypes from 'prop-types';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';
import { RequestFactory } from 'app/src/functions/RequestFactory';


const componentName   = "RCTContextMenu";
const NativeCommands  = UIManager[componentName]?.Commands;
const NativeComponent = requireNativeComponent(componentName);


export const ImageTypes = {
  'NONE'  : 'NONE'  ,
  'URL '  : 'URL'   ,
  'SYSTEM': 'SYSTEM',
};

export const MenuOptions = {
  destructive  : 'destructive'  ,
  displayInline: 'displayInline',
};

export const MenuElementAtrributes = {
  hidden     : 'hidden'     ,
  disabled   : 'disabled'   ,
  destructive: 'destructive',
};

export const MenuElementState = {
  on   : 'on'   ,
  off  : 'off'  ,
  mixed: 'mixed',
};

export const MenuItemKeys = {
  key           : 'key'           , // unique identifier
  title         : 'title'         , // string value
  imageType     : 'imageType'     , // ImageTypes item
  imageValue    : 'imageValue'    , // string value
  menuState     : 'menuState'     , // MenuElementState item
  menuAttributes: 'menuAttributes', // MenuElementAtrributes item
};

const PROP_KEYS = {
  menuTitle: 'menuTitle',

  menuItems  : 'menuItems'  ,
  menuOptions: 'menuOptions',

  onPressMenuItem: 'onPressMenuItem',
};


export class ContextMenuView extends React.PureComponent {

  _handleOnPressMenuItem = ({nativeEvent}) => {
    console.log(nativeEvent);
    alert(nativeEvent.key);
  };

  render(){

    const nativeProps = {
      ...this.props,
      [PROP_KEYS.onPressMenuItem]: this._handleOnPressMenuItem,
    };

    return(
      <NativeComponent
        {...nativeProps}
      />
    );
  };
};
