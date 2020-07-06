import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';

import * as Helpers from 'app/src/functions/helpers';
import { RequestFactory } from 'app/src/functions/RequestFactory';

const componentName  = "RCTListOrderView";
const NativeCommands = UIManager[componentName].Commands;
const NativeViewComp = requireNativeComponent(componentName);

const PROP_KEYS = {
  listData  : 'listData'  ,
  descLabel : 'descLabel' ,
  isEditable: 'isEditable',

  onRequestResult: 'onRequestResult',
};

const COMMAND_KEYS = {
  requestListData: 'requestListData'
};

export class ListOrderView extends React.PureComponent {
  constructor(props){
    super(props);
    RequestFactory.initialize(this);
  };

  requestListData = async () => {
    try {
      const { promise, requestID } = 
        RequestFactory.newRequest(this);

      // request 
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeCompRef),
        NativeCommands[COMMAND_KEYS.requestListData],
        [requestID]
      );

      const res = await promise;
      return res.listItems;

    } catch(error){
      console.log("ListOrderView, requestListData failed:");
      console.log(error);
    };
  };

  _handleOnRequestResult = ({nativeEvent}) => {
    RequestFactory.resolveRequestFromObj(this, nativeEvent);
  };
  
  render(){
    const props = {
      ...this.props,
      // Native Props
      [PROP_KEYS.onRequestResult]: this._handleOnRequestResult
    };

    return(
      <NativeViewComp
        ref={r => this.nativeCompRef = r}
        {...props}
      />
    );
  };
};