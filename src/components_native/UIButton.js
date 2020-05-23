import React from 'react';
import { requireNativeComponent, Alert } from 'react-native';

 
export class UIButton extends React.PureComponent {
  _handleOnPress = (event) => {
    const { onPress } = this.props;
    onPress && onPress();
    Alert.alert('Button Clicked');
  };

  render() {
    return(
      <RCTUIButton
        {...this.props}
        label={"Test1"}
        labelValue2={"Test 2"}
        onClick={this._handleOnPress}
        config={{
          labelValue: this.props?.label2 ?? ''
        }}
      />
    );
  };
};

const RCTUIButton = requireNativeComponent('RCTUIButton')