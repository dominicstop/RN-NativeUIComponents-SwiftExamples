import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';

const componentName   = "RCTModalView";
const NativeCommands  = UIManager[componentName]?.Commands;
const NativeModalView = requireNativeComponent(componentName);


const PROP_KEYS = {
  // Modal Native Props: Event Callbacks
  onRequestResult      : 'onRequestResult'      ,
  onModalShow          : 'onModalShow'          ,
  onModalDismiss       : 'onModalDismiss'       ,
  onModalDidDismiss    : 'onModalDidDismiss'    ,
  onModalWillDismiss   : 'onModalWillDismiss'   ,
  onModalAttemptDismiss: 'onModalAttemptDismiss',

  // Modal Native Props: Flags/Booleans
  presentViaMount      : 'presentViaMount'      ,
  isModalBGBlurred     : 'isModalBGBlurred'     ,
  isModalBGTransparent : 'isModalBGTransparent' ,
  isModalInPresentation: 'isModalInPresentation',

  // Modal Native Props: Strings
  modalTransitionStyle  : 'modalTransitionStyle'  ,
  modalPresentationStyle: 'modalPresentationStyle',
  modalBGBlurEffectStyle: 'modalBGBlurEffectStyle',
};

const COMMAND_KEYS = {
  requestModalPresentation: 'requestModalPresentation'
};

export const UIBlurEffectStyles = {
  // Adaptable Styles -------------------------------
  systemUltraThinMaterial: "systemUltraThinMaterial",
  systemThinMaterial     : "systemThinMaterial"     ,
  systemMaterial         : "systemMaterial"         ,
  systemThickMaterial    : "systemThickMaterial"    ,
  systemChromeMaterial   : "systemChromeMaterial"   ,
  // Light Styles ---------------------------------------------
  systemMaterialLight         : "systemMaterialLight"         ,
  systemThinMaterialLight     : "systemThinMaterialLight"     ,
  systemUltraThinMaterialLight: "systemUltraThinMaterialLight",
  systemThickMaterialLight    : "systemThickMaterialLight"    ,
  systemChromeMaterialLight   : "systemChromeMaterialLight"   ,
  // Dark Styles --------------------------------------------
  systemChromeMaterialDark   : "systemChromeMaterialDark"   ,
  systemMaterialDark         : "systemMaterialDark"         ,
  systemThickMaterialDark    : "systemThickMaterialDark"    ,
  systemThinMaterialDark     : "systemThinMaterialDark"     ,
  systemUltraThinMaterialDark: "systemUltraThinMaterialDark",
  // Additional Styles ----
  regular   : "regular"   ,
  prominent : "prominent" ,
  light     : "light"     ,
  extraLight: "extraLight",
  dark      : "dark"      ,
};

export const UIModalPresentationStyles = {
  automatic         : 'automatic'     ,
  fullScreen        : 'fullScreen'    ,
  pageSheet         : 'pageSheet'     ,
  formSheet         : 'formSheet'     ,
  overFullScreen    : 'overFullScreen',
  /* NOT SUPPORTED
  none              : 'none'              ,
  currentContext    : 'currentContext'    ,
  custom            : 'custom'            ,
  overFullScreen    : 'overFullScreen'    ,
  overCurrentContext: 'overCurrentContext',
  popover           : 'popover'           ,
  blurOverFullScreen: 'blurOverFullScreen',
  */
};

export const UIModalTransitionStyles = {
  coverVertical : 'coverVertical' ,
  crossDissolve : 'crossDissolve' ,
  flipHorizontal: 'flipHorizontal',
  /* NOT SUPPORTED
  partialCurl   : 'partialCurl'   ,
  */
};

export class ModalView extends React.PureComponent {
  static proptypes = {
    // Props: Events ---------------------
    onRequestResult      : Proptypes.func,
    onModalShow          : Proptypes.func,
    onModalDismiss       : Proptypes.func,
    onModalDidDismiss    : Proptypes.func,
    onModalWillDismiss   : Proptypes.func,
    onModalAttemptDismiss: Proptypes.func,
    // Props: Bool/Flags --------------------------
    presentViaMount                : Proptypes.bool,
    isModalBGBlurred               : Proptypes.bool,
    isModalBGTransparent           : Proptypes.bool,
    isModalInPresentation          : Proptypes.bool,
    setModalInPresentationFromProps: Proptypes.bool,
    // Props: String ------------------------
    modalTransitionStyle  : Proptypes.string,
    modalPresentationStyle: Proptypes.string,
    modalBGBlurEffectStyle: Proptypes.string,
  };

  static defaultProps = {
    isModalInPresentation: false,
    setModalInPresentationFromProps: false,
  };

  constructor(props){
    super(props);

    this.requestID  = 0;
    this.requestMap = new Map();

    this._childRef = null;

    this.state = {
      visible: false,
      childProps: null,
      isModalInPresentation: props.isModalInPresentation,
    };
  };

  setVisibilty = async (nextVisible, childProps = null) => {
    const { visible: prevVisible } = this.state;

    const didChange = (prevVisible != nextVisible);
    if (!didChange) return false;

    try {
      if(nextVisible) {
        // when showing modal, mount children first,
        await Helpers.setStateAsync(this, {
          visible: nextVisible, 
          // pass down received props to childProps via state
          childProps: (_.isObject(childProps)
            ? childProps
            : null
          ),
        });

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
        [requestID, nextVisible]
      );

      const res = await new Promise((resolve, reject) => {
        this.requestMap[requestID] = { resolve, reject };
      });

      // when finish hiding modal, unmount children
      if(!nextVisible) await Helpers.setStateAsync(this, {
        visible   : nextVisible,
        childProps: null
      });

      return res.success;

    } catch(error){
      console.log(
          "ModalView, setVisibilty error"
        + ` - Error Code: ${error.errorCode   }`
        + ` - Error Mesg: ${error.errorMessage}`
      );

      return false;
    };
  };

  setIsModalInPresentation = (bool) => {
    this.setState({ isModalInPresentation: bool });
  };

  _handleOnLayout = () => {
    const { didOnLayout } = this;
    didOnLayout && didOnLayout();
  };
  
  _handleChildRef = (node) => {
    // store a copy of the child comp ref
    this._childRef = node;
    
    // pass down ref
    const { ref } = this.props.children;
    if (typeof ref === 'function') {
      ref(node);
      
    } else if (ref !== null) {
      ref.current = node;
    };
  };

  // the child comp can call `props.getModalRef` to receive
  // a ref to this modal comp
  _handleChildGetRef = () => {
    return this;
  };

  //#region - Native Event Handlers

  _handleOnRequestResult = ({nativeEvent}) => {
    const { requestID, success, errorCode, errorMessage } = nativeEvent;

    const promise = this.requestMap[requestID];
    if(!promise) return;

    const params = { requestID, success, errorCode, errorMessage};

    try {
      (success? promise.resolve : promise.reject)(params);
      this.props     .onRequestResult?.();
      this._childRef?.onRequestResult?.();
  
    } catch(error){
      promise.reject(params);
      console.log("ModalView, _handleOnRequestResult: failed");
      console.log(error);
    };
  };

  _handleOnModalShow = () => {
    this.props     .onModalShow?.();
    this._childRef?.onModalShow?.();
  };

  _handleOnModalDismiss = () => {
    this.props     .onModalDismiss?.();
    this._childRef?.onModalDismiss?.();

    this.setState({ 
      visible   : false,
      childProps: null ,
      isModalInPresentation:
        this.props.isModalInPresentation
    });
  };

  _handleOnModalDidDismiss = () => {
    this.props     .onModalDidDismiss?.();
    this._childRef?.onModalDidDismiss?.();
  };

  _handleOnModalWillDismiss = () => {
    this.props     .onModalWillDismiss?.();
    this._childRef?.onModalWillDismiss?.();
  };

  _handleOnModalAttemptDismiss = () => {
    this.props     .onModalAttemptDismiss?.();
    this._childRef?.onModalAttemptDismiss?.();
  };

  //#endregion

  render(){
    const state = this.state;
    const children   = this.props.children;
    const childCount = React.Children.count(children);

    const nativeProps = {
      [PROP_KEYS.onModalShow          ]: this._handleOnModalShow          ,
      [PROP_KEYS.onModalDismiss       ]: this._handleOnModalDismiss       ,
      [PROP_KEYS.onRequestResult      ]: this._handleOnRequestResult      ,
      [PROP_KEYS.onModalDidDismiss    ]: this._handleOnModalDidDismiss    ,
      [PROP_KEYS.onModalWillDismiss   ]: this._handleOnModalWillDismiss   ,
      [PROP_KEYS.onModalAttemptDismiss]: this._handleOnModalAttemptDismiss,
    };

    const props = {
      ...this.props ,
      ...nativeProps,
      ...(this.props.setModalInPresentationFromProps && {
        [PROP_KEYS.isModalInPresentation]: state.isModalInPresentation
      }),
    };

    return(
      <NativeModalView
        ref={r => this.nativeModalViewRef = r}
        style={styles.rootContainer}
        {...props}
      >
        {state.visible && (
          <View 
            ref={r => this.modalContainerRef = r}
            style={[styles.modalContainer, props.containerStyle]}
            onLayout={this._handleOnLayout}
          >
            {React.cloneElement(children, {
              getModalRef: this._handleChildGetRef,
              // pass down props received from setVisibility
              ...(_.isObject(state.childProps) && state.childProps),
              ...(childCount == 1 && {
                ref: this._handleChildRef
              })
            })}
          </View>
        )}
      </NativeModalView>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    position: 'absolute',
  },
  modalContainer: {
    position: 'absolute',
  },
});