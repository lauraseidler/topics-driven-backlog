import Vue from 'vue';

/**
 * Bind click handler
 * @param {*} el 
 * @param {*} binding 
 */
function bind(el, binding) {
    el.handleClick = () => {            
        if (confirm('Are you sure? This action is irreversible.')) {
            binding.value();
        }
    };

    el.addEventListener('click', el.handleClick);
}

/**
 * Unbind click handler
 * @param {*} el 
 */
function unbind(el) {
    el.removeEventListener('click', el.handleClick);
}

/**
 * v-confirm directive, asking the user to confirm the action before
 * a click event on an item is processed
 */
Vue.directive('confirm', {
    bind,
    unbind,
    componentUpdated(el, binding) {
        if (binding.value !== binding.oldValue) {
            bind(el, binding);
        }
    },
});
