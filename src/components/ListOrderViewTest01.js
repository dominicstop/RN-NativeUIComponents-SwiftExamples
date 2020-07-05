import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';

import _ from 'lodash';

import * as Helpers from 'app/src/functions/helpers';
import { ListOrderView } from 'app/src/components_native/ListOrder';


let DUMMY_DATA = _.range(0, 5).map(index => ({
  id         : `id-${index}`,
  title      : `Title from RN Props #${index}`      ,
  description: `Description from RN Props #${index}`,
}));


export class ListOrderViewTest01 extends React.PureComponent {
  constructor(props){
    super(props);

    this.state = {
      listData: [...DUMMY_DATA]
    };
  };

  async componentDidMount(){
    await Helpers.timeout(3000);

    const listData = await this.listOrderRef.requestListData();
    console.log("listData: ");
    console.log(listData);

    return;

    for (const index of _.range(6, 10)) {
      await Helpers.timeout(1000);
      
      const prevListData = this.state.listData;
      console.log("adding new item");
      await Helpers.setStateAsync(this, {
        listData: [...prevListData, {
          id         : `id-${index}`,
          title      : `New Title from RN Props #${index}`      ,
          description: `New Description from RN Props #${index}`,
        }]
      });
    };

    
  };

  render(){
    return(
      <View style={styles.rootContainer}>
        <ListOrderView
          ref={r => this.listOrderRef = r}
          style={styles.list}
          listData={this.state.listData}
          descLabel={"Desc: "}
          isEditable={true}
        />
      </View>
    );
  };
};

const styles = StyleSheet.create({
  rootContainer: {
    flex: 1,
  },
  list: {
    flex: 1,
  },
});