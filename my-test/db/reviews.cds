namespace my.TestService;

using {
    User,
    managed,
    cuid
} from '@sap/cds/common';
using my.TestService.Tests from './data-model';

type Rating : Integer enum {
    Best  = 5;
    Good  = 4;
    Avg   = 3;
    Poor  = 2;
    Worst = 1;
}

annotate Reviews with {
    title @mandatory;
    rating @assert.range;
    test @mandatory @assert.target;
}

entity Reviews : cuid, managed {
    @cds.odata.ValueList
    test     : Association to Tests;
    rating   : Rating;
    title    : String(111);
    text     : String(1111);
}