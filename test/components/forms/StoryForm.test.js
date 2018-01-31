import { mount } from 'vue-test-utils';
import StoryForm from '@/components/forms/StoryForm';

describe('StoryForm.test.js', () => {
    let cmp;

    beforeEach(() => {
        cmp = mount(StoryForm, {
            propsData: {
                data: {
                    title: 'Test Story',
                    points: 5,
                },
                project: {
                    id: 1,
                    course_id: 1,
                },
            },
            mocks: {
                $store: {
                    getters: {
                        'topics/all': () => [],
                    },
                },
            },
        });
    });

    it('is a form with class story-form', () => {
        expect(cmp.is('form.story-form'));
    });

    it('doesnt calculate topics if no project is set', () => {
        const props = cmp.props;
        props.project = null;
        cmp.setProps(props);

        expect(cmp.vm.topics.length).toBe(0);
    });
});
