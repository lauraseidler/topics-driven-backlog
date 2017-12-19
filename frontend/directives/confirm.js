import Vue from 'vue';

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