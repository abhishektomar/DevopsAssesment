<?php

namespace TradeTracker\AssesmentBundle\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Setup
 */
class Setup
{
    /**
     * @var integer
     */
    private $id;


    /**
     * Get id
     *
     * @return integer 
     */
    public function getId()
    {
        return $this->id;
    }
}
