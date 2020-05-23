import React from 'react';
import { requireNativeComponent } from 'react-native';
 
const RCTRedBoxTestView = requireNativeComponent('RedBoxTestView');
 
export class RedBoxTestView extends React.PureComponent {
  _onClick = (event) => {
    if (!this.props.onClick) {
      return;
    };
 
    // process raw event...
    this.props.onClick(event.nativeEvent);
  };
 
  render() {
    return(
      <RCTRedBoxTestView 
        onClick={this._onClick} 
        {...this.props} 
      />
    );
  };
}