import { mount } from 'vue-test-utils';
import '@/directives/sortable';

describe('sortable.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount({
            template: '<div v-sortable></div>',
        });
    });

    it('puts an instance of sortable plugin on the element', () => {
        expect(cmp.vm.sortableInstance).toBeTruthy();
    });
});
