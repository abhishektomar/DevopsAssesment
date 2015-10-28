<?php

use Doctrine\ORM\Mapping\ClassMetadataInfo;

$metadata->setInheritanceType(ClassMetadataInfo::INHERITANCE_TYPE_NONE);
$metadata->setChangeTrackingPolicy(ClassMetadataInfo::CHANGETRACKING_DEFERRED_IMPLICIT);
$metadata->mapField(array(
   'fieldName' => 'id',
   'type' => 'integer',
   'id' => true,
   'columnName' => 'id',
  ));
$metadata->mapField(array(
   'columnName' => 'first_name',
   'fieldName' => 'firstName',
   'type' => 'string',
   'length' => '63',
  ));
$metadata->mapField(array(
   'columnName' => 'last_name',
   'fieldName' => 'lastName',
   'type' => 'string',
   'length' => '63',
  ));
$metadata->mapField(array(
   'columnName' => 'age',
   'fieldName' => 'age',
   'type' => 'smallint',
  ));
$metadata->setIdGeneratorType(ClassMetadataInfo::GENERATOR_TYPE_AUTO);