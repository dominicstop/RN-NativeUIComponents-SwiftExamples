import React from 'react';
import { requireNativeComponent, StyleSheet, View, Text } from 'react-native';
 
const NativeModalView = requireNativeComponent('RCTModalView');

export class ModalView extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      visible: false
    };
  };

  setVisibilty = (visible) => {
    this.setState({visible});

    const prevVisible = this.state.visible;

    if(prevVisible != visible){
      
    };
  };

  render(){
    if(!this.state.visible) return null;

    return(
      <NativeModalView>
        <View style={styles.modalContainer}>
          {this.props.children}
        </View>
      </NativeModalView>
    );
  };
};

const styles = StyleSheet.create({
  modalContainer: {
    position: 'absolute',
  },
});