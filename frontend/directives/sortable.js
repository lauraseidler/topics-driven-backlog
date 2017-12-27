import Vue from 'vue';
import * as Sortable from 'sortablejs/Sortable';

/**
 * v-sortable directive, binding Sortable plugin to a list
 */
Vue.directive('sortable', {
    inserted: function(el, binding) {
        new Sortable(el, binding.value || {});
    },
});
