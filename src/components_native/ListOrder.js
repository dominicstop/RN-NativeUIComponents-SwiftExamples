import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';

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

    this.requestID  = 1;
    this.requestMap = {};
  };

  requestListData = async () => {
    try {
      // new requestID
      const requestID = this.requestID++;

      // request 
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeCompRef),
        NativeCommands[COMMAND_KEYS.requestListData],
        [requestID]
      );

      const res = await new Promise((resolve, reject) => {
        this.requestMap[requestID] = { resolve, reject };
      });

      return res.listItems;

    } catch(error){
      console.log("ListOrderView, requestListData failed:");
      console.log(error);
    };
  };

  _handleOnRequestResult = ({nativeEvent}) => {
    const { requestID, ...otherArgs } = nativeEvent;

    const promise = this.requestMap[requestID];
    if(!promise) return;

    const params = { requestID, ...otherArgs };

    try {
      (success? promise.resolve : promise.reject)(params);
      this.props.onRequestResult?.();
  
    } catch(error){
      promise.reject(params);
      console.log("ListOrderView, _handleOnRequestResult: failed");
      console.log(error);
    };
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