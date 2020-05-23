import React from 'react';
import { requireNativeComponent } from 'react-native';
 
const RCTUIPageView = requireNativeComponent('UIPageView');
 
export class UIPageView extends React.PureComponent { 
  render() {
    return(
      <RCTUIPageView 
        {...this.props} 
      />
    );
  };
}