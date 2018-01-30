import { mount } from 'vue-test-utils';
import '@/directives/sortable';

describe('sortable.test.js', () => {
    let cmp;

    it('puts an instance of sortable plugin on the element', () => {
        cmp = mount({
            template: '<div v-sortable="{}"></div>',
        });

        expect(cmp.vm.sortableInstance).toBeTruthy();
    });

    it('does not put an instance of sortable plugin on the element if value null', () => {
        cmp = mount({
            template: '<div v-sortable="null"></div>',
        });

        expect(cmp.vm.sortableInstance).toBeFalsy();
    });
});
