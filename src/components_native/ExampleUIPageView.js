import React from 'react';
import { requireNativeComponent } from 'react-native';
 
const NativeExampleUIPageView = requireNativeComponent('ExampleUIPageView');
 
export class ExampleUIPageView extends React.PureComponent { 
  render() {
    return(
      <NativeExampleUIPageView 
        {...this.props} 
      />
    );
  };
}