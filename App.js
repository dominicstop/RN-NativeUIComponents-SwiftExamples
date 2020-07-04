import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import { UIButton          } from 'app/src/components_native/UIButton';
import { UIPageView        } from 'app/src/components_native/UIPageView';
import { ChildTestView     } from 'app/src/components_native/ChildTestView';
import { RedBoxTestView    } from 'app/src/components_native/RedBoxTestView';
import { BlueBoxTestView   } from 'app/src/components_native/BlueBoxTestView';
import { ExampleUIPageView } from 'app/src/components_native/ExampleUIPageView';
import { ModalView } from 'app/src/components_native/ModalView';

import { ModalViewTest1  } from 'app/src/components/ModalViewTest1';
import { UIPageViewTest1 } from 'app/src/components/UIPageViewTest1';

import * as Helpers from 'app/src/functions/helpers';
import { RCTQuizQuestionEditListManager } from './src/components_native/QuizQuestionEditList';


export default class App extends React.Component {

  render(){
    return(
      <View style={{flex: 1}}>
        <RCTQuizQuestionEditListManager/>
      </View>
    );

    //#region 
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
    //#endregion
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
  modalContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center'
  },
  textModal: {
    fontSize: 24,
    fontWeight: '700',
  },
});
