import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';

const componentName  = "RCTQuizQuestionEditList";
const NativeCommands = UIManager[componentName]?.Commands;
const NativeViewComp = requireNativeComponent(componentName);


export class RCTQuizQuestionEditListManager extends React.PureComponent {
  render(){
    return(
      <NativeViewComp
        style={{ flex: 1 }}
      />
    );
  };
};