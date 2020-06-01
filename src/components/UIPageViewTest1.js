import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';


import { iOSUIKit, sanFranciscoWeights } from 'react-native-typography';
import { UIPageView } from 'app/src/components_native/UIPageView';

export class UIPageViewTest1 extends React.PureComponent {
  render(){
    return(
      <UIPageView style={{flex: 1}}>
        <View style={[styles.page]}>
          <View>
            <Text style={styles.textTitle}>
              {'Your Silence is Deafening'}
            </Text>
            <Text style={styles.textDescription}>
              {`I don't understand how the tech community is staying quiet at a time like this.`}
            </Text>
            <View style={styles.divider}/>
            <Text style={styles.textTitle2}>
              {"Why Are You Staying Quiet?"}
            </Text>
            <Text style={styles.textDescription}>
              {`I don't understand how people in the tech community with thousands of followers are choosing not to say anything.`}
            </Text>
            <View style={styles.divider}/>
            <Text style={styles.textTitle2}>
              {"Because It Doesn't Affect You?"}
            </Text>
            <Text style={styles.textDescription}>
              {`Is it because you don't want to lose followers? Because you don't want to "tarnish" your brand? Because you don't want to.`}
            </Text>
          </View>
        </View>
        <View style={[styles.page]}>
          <View>
            <Text style={styles.textTitle}>
              {"Because You Don't Care"}
            </Text>
            <Text style={styles.textDescription}>
              {`How can you still tweet about tech and programming at a time like this?`}
            </Text>
            <View style={styles.divider}/>
            <Text style={styles.textTitle2}>
              {"Why Not Use Your Platform?"}
            </Text>
            <Text style={styles.textDescription}>
              {`Even if you can't help out directly, you can still like/RT to spread the cause.`}
            </Text>
            <View style={styles.divider}/>
            <Text style={styles.textTitle2}>
              {"Why not use your voice?"}
            </Text>
            <Text style={styles.textDescription}>
              {`No matter how big or small your platform is, use your voice for a good cause. Silence is the real crime against humanity.`}
            </Text>
          </View>
        </View>
      </UIPageView>
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
    backgroundColor: 'white',
    paddingHorizontal: 13,
    paddingVertical: 50,
  },
  textTitle: {
    ...iOSUIKit.largeTitleEmphasizedObject,
    fontSize: 38,
    fontWeight: '800',
    paddingRight: 10,
  },
  textTitle2: {
    ...iOSUIKit.bodyEmphasizedObject,
    ...sanFranciscoWeights.heavy,
    fontSize: 20,
  },
  textDescription: {
    ...iOSUIKit.bodyObject,
    marginTop: 5,
    color: 'rgba(0,0,0,0.8)',
  },
  divider: {
    width: '100%',
    height: 30,
  },
});