import Vue from 'vue';
import * as Sortable from 'sortablejs/Sortable';

Vue.directive('sortable', {
    inserted: function (el, binding) {
        new Sortable(el, binding.value || {});
    }
});