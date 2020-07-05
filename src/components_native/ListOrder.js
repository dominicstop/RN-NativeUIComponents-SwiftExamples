import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';

const componentName  = "RCTListOrderView";
const NativeCommands = UIManager[componentName]?.Commands;
const NativeViewComp = requireNativeComponent(componentName);

const PROP_KEYS = {
  listData  : 'listData'  ,
  descLabel : 'descLabel' ,
  isEditable: 'isEditable',
};

export class ListOrderView extends React.PureComponent {
  render(){
    return(
      <NativeViewComp
        {...this.props}
      />
    );
  };
};