import { mount } from 'vue-test-utils';
import '@/directives/confirm';

describe('confirm.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount({
            template: '<button v-confirm="test"></button>',
            methods: {
                test: () => null,
            },
        });
    });

    it('calls method when click is confirmed', () => {
        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp.vm.test = jest.fn();
        cmp.update();
        cmp.trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.test).toHaveBeenCalled();
    });

    it('does not call method when click is not confirmed', () => {
        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => false);

        cmp.vm.test = jest.fn();
        cmp.update();
        cmp.trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.test).not.toHaveBeenCalled();
    });

    it('calls method when click is confirmed with verbose parameter', () => {
        cmp = mount({
            template: '<button v-confirm="{ action: test, text: \'Sure?\' }"></button>',
            methods: {
                test: () => null,
            },
        });

        const confirmSpy = jest
            .spyOn(window, 'confirm')
            .mockImplementation(() => true);

        cmp.vm.test = jest.fn();
        cmp.update();
        cmp.trigger('click');

        expect(confirmSpy).toHaveBeenCalled();
        expect(cmp.vm.test).toHaveBeenCalled();
    });
});
