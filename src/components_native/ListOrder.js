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

  onRequestResult  : 'onRequestResult'  ,
  onListItemsChange: 'onListItemsChange',
};

const COMMAND_KEYS = {
  requestListData   : 'requestListData'   ,
  requestSetListData: 'requestSetListData',
};

export class ListOrderView extends React.PureComponent {
  constructor(props){
    super(props);

    this._listItems = [];
    RequestFactory.initialize(this);
  };

  requestListData = async () => {
    const { promise, requestID } = 
      RequestFactory.newRequest(this, { timeout: 1000 });

    try {
      // request 
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeCompRef),
        NativeCommands[COMMAND_KEYS.requestListData],
        [requestID]
      );

      const result = await promise;
      return result.listItems;

    } catch(error){
      console.log("ListOrderView, requestListData failed:");
      console.log(error);
      RequestFactory.rejectRequest(this, { requestID });
    };
  };

  requestSetListData = async (listItems = []) => {
    const { promise, requestID } = 
      RequestFactory.newRequest(this, { timeout: 1000 });

    try {
      // request 
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeCompRef),
        NativeCommands[COMMAND_KEYS.requestSetListData],
        [requestID, listItems]
      );

      const result = await promise;
      return;

    } catch(error){
      console.log("ListOrderView, requestSetListData failed:");
      console.log(error);
      RequestFactory.rejectRequest(this, { requestID });
    };
  };

  _handleOnRequestResult = ({nativeEvent}) => {
    RequestFactory.resolveRequestFromObj(this, nativeEvent);
  };

  _handleOnListItemsChange = ({nativeEvent}) => {
    const { listItems } = nativeEvent;

    this._listItems = listItems;
    this.props.onListItemsChange?.(listItems);

    console.log("_handleOnListItemsChange listItems: ");
    console.log(listItems);
  };
  
  render(){
    const props = {
      ...this.props,
      // Native Props
      [PROP_KEYS.onRequestResult  ]: this._handleOnRequestResult,
      [PROP_KEYS.onListItemsChange]: this._handleOnListItemsChange,
    };

    return(
      <NativeViewComp
        ref={r => this.nativeCompRef = r}
        {...props}
      />
    );
  };
};