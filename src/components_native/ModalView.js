import React from 'react';
import Proptypes from 'prop-types';
import { requireNativeComponent, UIManager, findNodeHandle, StyleSheet, View, ScrollView } from 'react-native';

import _ from 'lodash';
import * as Helpers from 'app/src/functions/helpers';
import { RequestFactory } from 'app/src/functions/RequestFactory';


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
  modalID               : 'modalID'               ,
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

const VirtualizedListContext = React.createContext(null);

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

    RequestFactory.initialize(this);
    this._childRef = null;

    this.state = {
      visible: false,
      childProps: null,
      isModalInPresentation: props.isModalInPresentation,
    };
  };

  setVisibility = async (nextVisible, childProps = null) => {
    const { visible: prevVisible } = this.state;

    const didChange = (prevVisible != nextVisible);
    if (!didChange) return false;

    const { promise, requestID } = 
      RequestFactory.newRequest(this, { timeout: 2000 });

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

      // request modal to open/close
      UIManager.dispatchViewManagerCommand(
        findNodeHandle(this.nativeModalViewRef),
        NativeCommands[COMMAND_KEYS.requestModalPresentation],
        [requestID, nextVisible]
      );

      const result = await promise;

      // when finish hiding modal, unmount children
      if(!nextVisible) await Helpers.setStateAsync(this, {
        visible   : nextVisible,
        childProps: null
      });

      return result.success;

    } catch(error){
      RequestFactory.rejectRequest(this, {requestID});
      console.log("ModalView, setVisibility failed:");
      console.log(error);

      return false;
    };
  };

  setIsModalInPresentation = (isModalInPresentation) => {
    const { isModalInPresentation: prevVal } = this.state;
    if(prevVal != isModalInPresentation){
      this.setState({ isModalInPresentation });
    };
  };

  // We don't want any responder events bubbling out of the modal.
  _shouldSetResponder() {
    return true;
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
    RequestFactory.resolveRequestFromObj(this, nativeEvent);
    this.props     .onRequestResult?.(nativeEvent);
    this._childRef?.onRequestResult?.(nativeEvent);
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
    const props = this.props;
    const state = this.state;

    const nativeProps = {
      [PROP_KEYS.onModalShow          ]: this._handleOnModalShow          ,
      [PROP_KEYS.onModalDismiss       ]: this._handleOnModalDismiss       ,
      [PROP_KEYS.onRequestResult      ]: this._handleOnRequestResult      ,
      [PROP_KEYS.onModalDidDismiss    ]: this._handleOnModalDidDismiss    ,
      [PROP_KEYS.onModalWillDismiss   ]: this._handleOnModalWillDismiss   ,
      [PROP_KEYS.onModalAttemptDismiss]: this._handleOnModalAttemptDismiss,
      // pass down props
      ...props, ...nativeProps,
      ...(this.props.setModalInPresentationFromProps && {
        [PROP_KEYS.isModalInPresentation]: state.isModalInPresentation
      }),
    };

    return(
      <NativeModalView
        ref={r => this.nativeModalViewRef = r}
        style={styles.rootContainer}
        onStartShouldSetResponder={this._shouldSetResponder}
        {...nativeProps}
      >
        <VirtualizedListContext.Provider value={null}>
          <ScrollView.Context.Provider value={null}>
            {state.visible && (
              <View 
                ref={r => this.modalContainerRef = r}
                style={[styles.modalContainer, props.containerStyle]}
                collapsable={false}
                onLayout={this._handleOnLayout}
              >
                {React.cloneElement(this.props.children, {
                  ref        : this._handleChildRef   ,
                  getModalRef: this._handleChildGetRef,
                  // pass down props received from setVisibility
                  ...(_.isObject(state.childProps) && state.childProps),
                  // pass down modalID
                  modalID: props[PROP_KEYS.modalID]
                })}
              </View>
            )}
          </ScrollView.Context.Provider>
        </VirtualizedListContext.Provider>
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
    top: 0,
    left: 0,
    right: 0,
  },
});