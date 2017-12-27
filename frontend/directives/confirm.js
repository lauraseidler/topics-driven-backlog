import Vue from 'vue';

/**
 * v-confirm directive, asking the user to confirm the action before
 * a click event on an item is processed
 */
Vue.directive('confirm', {
    bind(el, binding) {
        el.handleClick = () => {
            if (confirm('Are you sure? This action is irreversible.')) {
                binding.value();
            }
        };

        el.addEventListener('click', el.handleClick);
    },
    unbind(el) {
        el.removeEventListener('click', el.handleClick);
    },
});
