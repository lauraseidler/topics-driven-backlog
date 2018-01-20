import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';
import { current } from '@/helper/semester';

const resourceModule = generate({
    resource: resources.COURSES,
    children: [resources.SPRINTS, resources.PROJECTS, resources.TOPICS],
    template: () => {
        return {
            semester: current().valueString,
            allow_enrollment: true,
        };
    },
});

export default resourceModule;
