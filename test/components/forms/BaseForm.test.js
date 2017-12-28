import { mount } from 'vue-test-utils';
import BaseForm from '@/components/forms/BaseForm';

describe('BaseForm.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(BaseForm);
    });

    it('shows warning to not instantiate', () => {
        expect(cmp.find('p').text()).toBe('BaseForm can\'t be instantiated!');
    });

    it('emits submit event on submit', () => {
        const stub = jest.fn();
        cmp.vm.$on('submit', stub);
        cmp.update();

        cmp.vm.submit();

        expect(stub).toHaveBeenCalled();
    });

    it('doesnt emit submit event when invalid', () => {
        const stub = jest.fn();
        cmp.vm.$on('cancel', stub);
        cmp.vm.$v = { $invalid: true };
        cmp.update();

        cmp.vm.submit();

        expect(stub).not.toHaveBeenCalled();
    });

    it('emits cancel event on cancel', () => {
        const stub = jest.fn();
        cmp.vm.$on('cancel', stub);
        cmp.update();

        cmp.vm.cancel();

        expect(stub).toHaveBeenCalled();
    });

    it('emits input event on data change', () => {
        cmp.setProps({ data: { test: 1 } });
        
        const stub = jest.fn();
        cmp.vm.$on('input', stub);
        cmp.update();

        cmp.vm.data.test = 2;

        cmp.vm.$nextTick(() => {
            expect(stub).toHaveBeenCalled();
        });
    });
});
