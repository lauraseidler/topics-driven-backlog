import Vue from 'vue';

/**
 * Bind click handler
 * @param {*} el 
 * @param {*} binding 
 */
function bind(el, binding) {
    // make sure to unbind any possible previous listener before attaching the new one
    unbind(el);

    el.handleClick = () => {
        if (confirm(binding.value.text || 'Are you sure? This action is irreversible.')) {
            if (binding.value.action) {
                binding.value.action();
            } else {
                binding.value();
            }
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
