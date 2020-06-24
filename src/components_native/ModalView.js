import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import * as Helpers from 'app/src/functions/helpers';


const componentName   = "RCTModalView";
const NativeCommands  = UIManager[componentName]?.Commands;
const NativeModalView = requireNativeComponent(componentName);

const PROP_KEYS = {
  onModalShow          : 'onModalShow'          ,
  onModalDismiss       : 'onModalDismiss'       ,
  onRequestResult      : 'onRequestResult'      ,
  presentViaMount      : 'presentViaMount'      ,
  isModalInPresentation: 'isModalInPresentation',
};

const COMMAND_KEYS = {
  requestModalPresentation: 'requestModalPresentation'
};

export class ModalView extends React.PureComponent {
  static proptypes = {
    onModalShow          : Proptypes.func,
    onModalDismiss       : Proptypes.func,
    presentViaMount      : Proptypes.bool,
    isModalInPresentation: Proptypes.bool,
  };

  constructor(props){
    super(props);

    this.requestID  = 0;
    this.requestMap = new Map();

    this.state = {
      visible: false
    };
  };

  setVisibilty = async (visible) => {
    const { visible: prevVisible } = this.state;

    const didChange = (prevVisible != visible);
    if (!didChange) return false;

    try {
      if(visible) {
        // when showing modal, mount children first,
        await Helpers.setStateAsync(this, {visible});
        // wait for view to mount
        await new Promise((resolve) => {
          this.didOnLayout = resolve;
        });

        // reset didOnLayout
        this.didOnLayout = null;
      };

      // new requestID
      const requestID = this.requestID++;
      
      // request modal to open/close
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeModalViewRef),
        NativeCommands[COMMAND_KEYS.requestModalPresentation],
        [requestID, visible]
      );

      console.log(`New RequestID: ${requestID}` );


      const success = await new Promise((resolve, reject) => {
        this.requestMap[requestID] = { resolve, reject };
      });

      // when finish hiding modal, unmount children
      if(!visible) await Helpers.setStateAsync(this, {visible});
      return success;

    } catch(error){
      console.log("ModalView, setVisibilty: error");
      console.log(error);

      return false;
    };
  };

  _handleOnLayout = () => {
    const { didOnLayout } = this;
    didOnLayout && didOnLayout();
  };

  //#region - Native Event Handlers

  _handleOnModalShow = () => {
    const { onModalShow } = this.props;
    onModalShow && onModalShow();
  };

  _handleOnModalDismiss = () => {
    const { onModalDismiss } = this.props;
    onModalDismiss && onModalDismiss();
  };

  _handleOnRequestResult = ({nativeEvent}) => {
    const { onRequestResult } = this.props;
    const { requestID, success, error } = nativeEvent;

    const promise = this.requestMap[requestID];
    if(!promise) return;

    
    console.log("_handleOnRequestResult");
    console.log(`requestID: ${requestID}`);
    console.log(`success: ${success}`);
    console.log(nativeEvent);

    try {
      (success? promise.resolve : promise.reject)(success);
      onRequestResult && onRequestResult(requestID, success);
  
    } catch(error){
      promise.reject(false);
    };
  };

  //#endregion

  render(){
    const props = this.props;
    const { visible } = this.state;

    const nativeProps = {
      [PROP_KEYS.onModalShow    ]: this._handleOnModalShow    ,
      [PROP_KEYS.onModalDismiss ]: this._handleOnModalDismiss ,
      [PROP_KEYS.onRequestResult]: this._handleOnRequestResult,
    };

    return(
      <NativeModalView
        ref={r => this.nativeModalViewRef = r}
        {...nativeProps}
      >
        {visible && (
          <View 
            ref={r => this.modalContainerRef = r}
            style={[styles.modalContainer, props.containerStyle]}
            onLayout={this._handleOnLayout}
          >
            {this.props.children}
          </View>
        )}
      </NativeModalView>
    );
  };
};

const styles = StyleSheet.create({
  modalContainer: {
    position: 'absolute',
  },
});