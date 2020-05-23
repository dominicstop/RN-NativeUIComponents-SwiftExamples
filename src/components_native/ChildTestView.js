

import React from 'react';
import { requireNativeComponent } from 'react-native';
 
const RCTChildTestView = requireNativeComponent('ChildTestView');
 
export class ChildTestView extends React.PureComponent {
  render() {
    return(
      <RCTChildTestView {...this.props}>
        {this.props.children}
      </RCTChildTestView>
    );
  };
}