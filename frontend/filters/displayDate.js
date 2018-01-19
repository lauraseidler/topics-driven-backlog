import Vue from  'vue';
import moment from 'moment';

Vue.filter('displayDate', (dateString) => {
    return moment(dateString).format('ddd, MMM Do YYYY');
});