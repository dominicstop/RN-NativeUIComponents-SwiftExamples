import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { UIButton          } from 'app/src/components_native/UIButton';
import { UIPageView        } from 'app/src/components_native/UIPageView';
import { ChildTestView     } from 'app/src/components_native/ChildTestView';
import { RedBoxTestView    } from 'app/src/components_native/RedBoxTestView';
import { BlueBoxTestView   } from 'app/src/components_native/BlueBoxTestView';
import { ExampleUIPageView } from 'app/src/components_native/ExampleUIPageView';
import { ModalView } from 'app/src/components_native/ModalView';

import { UIPageViewTest1 } from 'app/src/components/UIPageViewTest1';

export default class App extends React.Component {

  componentDidMount(){
    setTimeout(() => {
      this.modal1.setVisibilty(true);
    }, 2000);

    setTimeout(() => {
      this.modal2.setVisibilty(true);
    }, 4000);

    setTimeout(() => {
      this.modal2.setVisibilty(false);
    }, 6000);

    setTimeout(() => {
      this.modal2.setVisibilty(false);
    }, 8000);

    setTimeout(() => {
      this.modal1.setVisibilty(false);
    }, 10000);


    setTimeout(() => {
      this.modal1.setVisibilty(true);
    }, 12000);

    setTimeout(() => {
      this.modal2.setVisibilty(true);
    }, 14000);

    setTimeout(() => {
      this.modal2.setVisibilty(false);
    }, 16000);

    setTimeout(() => {
      this.modal1.setVisibilty(false);
    }, 18000);
  };

  render(){
    
    return(
      <View>
        <ModalView ref={r => this.modal1 = r}>
          <Text>Hello 1</Text>
          <ModalView ref={r => this.modal2 = r}>
            <Text>Hello 2</Text>
          </ModalView>
        </ModalView>
      </View>
    );
    return(
      <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
        <BlueBoxTestView
        />
      </View>
    );
    return(
      <View style={{flex: 1, backgroundColor: 'white'}}>
        <ExampleUIPageView style={{flex: 1}}/>
      </View>
    );
    return(
      <View style={{flex: 1, backgroundColor: 'white'}}>
        <UIPageViewTest1/>
      </View>
    );
    return (
      <View style={styles.container}>
        <RedBoxTestView
          style={{ width: 100, aspectRatio: 1 }}
          onClick={(params) => {
            console.log(params);
          }}
        />
        <ChildTestView
          style={{width: 100, height: 100, backgroundColor: 'grey'}}
        >
          <Text>Hello</Text>
        </ChildTestView>
        <UIButton
          style={{width: 100, height: 100, backgroundColor: 'orange'}}
          label2={'Test2'}
        />
      </View>
    );
  };
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  page: {
    ...StyleSheet.absoluteFillObject,
  },
});
