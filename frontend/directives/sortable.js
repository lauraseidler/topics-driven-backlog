import Vue from 'vue';
import * as Sortable from 'sortablejs/Sortable';

/**
 * v-sortable directive, binding Sortable plugin to a list
 */
Vue.directive('sortable', {
    inserted: function(el, binding, vnode) {
        if (binding.value) {
            vnode.context.sortableInstance = Sortable.create(el, binding.value);
        }
    },
});
