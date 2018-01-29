import { mount } from 'vue-test-utils';
import '@/filters/displayDate';

describe('displayDate.test.js', () => {
    let cmp;

    it('formats date correctly', () => {
        cmp = mount({
            template: '<div> {{ "2018-01-29" | displayDate }} </div>',
        });

        expect(cmp.find('div').text()).toBe('Mon, Jan 29th 2018');
    });
});
