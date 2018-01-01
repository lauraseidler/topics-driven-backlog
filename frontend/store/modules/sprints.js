import { generate } from '@/store/base/resource-module/index';
import resources from '@/store/resources';

const resourceModule = generate({
    resource: resources.SPRINTS,
    parent: resources.COURSES,
});

export default resourceModule;
