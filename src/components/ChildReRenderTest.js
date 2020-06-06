import React from 'react';
import { requireNativeComponent, View, Text } from 'react-native';
 
const NativeBlueBoxTestView = requireNativeComponent('BlueBoxTestView');

export class BlueBoxTestView extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      counter: 0
    };
  };

  componentDidMount(){
    this.timer = setInterval(() => {
      this.setState((prevState) => ({
        counter: (prevState.counter + 1)
      }));
    }, 3000);
  };

  componentWillUnmount(){
    if(this.timer){
      clearInterval(this.timer);
    };
  };

  render() {
    const { counter } = this.state;
    return(
      <NativeBlueBoxTestView
        style={{ minWidth: 10, minHeight: 10 }}
        nativeID={'uniqueID'}
        {...this.props}
      >
        <Text style={{position: 'absolute'}}>
          {counter + ' absolute'}
        </Text>
        {(counter % 2 == 0) && (
          <Text>
            {counter}
          </Text>
        )} 
        <View>
          <Text>Test</Text>
          <Text>Test</Text>
          <Text>Test</Text>
        </View>
      </NativeBlueBoxTestView>
    );
  };
}